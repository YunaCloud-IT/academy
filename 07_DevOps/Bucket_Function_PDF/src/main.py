import functions_framework
import os
import tempfile
from google.cloud import storage
import PyPDF2
from fpdf import FPDF
import vertexai
from vertexai.generative_models import GenerativeModel

# Cloud Functions automatically injects the active project ID into the environment
project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")

# 1. Explicitly force Vertex AI to use the same region as your Cloud Function
vertexai.init(project=project_id, location="europe-west3")

# 2. Use the newer model (fully available for new projects)
model = GenerativeModel("gemini-2.5-flash")

@functions_framework.cloud_event
def process_cv(cloud_event):
    """Triggered by Eventarc when a new file is uploaded to the input bucket."""

    # 1. Extract event data
    data = cloud_event.data
    input_bucket_name = data["bucket"]
    file_name = data["name"]

    # Only process PDF files
    if not file_name.lower().endswith(".pdf"):
        print(f"File {file_name} is not a PDF. Skipping.")
        return

    print(f"Processing file: {file_name} from bucket: {input_bucket_name}")

    storage_client = storage.Client()

    # Setup temporary local paths for processing
    _, temp_local_pdf = tempfile.mkstemp(suffix=".pdf")
    _, temp_out_pdf = tempfile.mkstemp(suffix=".pdf")

    try:
        # 2. Download the uploaded CV
        input_bucket = storage_client.bucket(input_bucket_name)
        blob = input_bucket.blob(file_name)
        blob.download_to_filename(temp_local_pdf)
        print("Successfully downloaded PDF to local storage.")

        # 3. Extract text from the PDF
        extracted_text = ""
        with open(temp_local_pdf, "rb") as f:
            reader = PyPDF2.PdfReader(f)
            for page in reader.pages:
                text = page.extract_text()
                if text:
                    extracted_text += text + "\n"

        if not extracted_text.strip():
            print("Could not extract any text from the PDF. Skipping.")
            return

        # 4. Generate summary using Vertex AI (Gemini)
        prompt = (
            "You are an expert HR assistant. Please analyze the following CV "
            "and provide a concise, structured summary including: "
            "1. Candidate Name\n"
            "2. Core Skills\n"
            "3. Summary of Experience\n"
            "4. Education.\n\n"
            f"CV Text:\n{extracted_text}"
        )

        response = model.generate_content(prompt)
        summary_text = response.text
        print("Successfully generated summary via Vertex AI.")

        # --- NEW ADDITION: Sanitize the text for Helvetica ---
        # Replace common Unicode characters Gemini uses with standard ASCII equivalents
        summary_text = (
            summary_text.replace("–", "-")   # en-dash to hyphen
            .replace("—", "-")               # em-dash to hyphen
            .replace("’", "'")               # smart single quote to standard
            .replace("‘", "'")               # smart single quote to standard
            .replace("“", '"')               # smart double quote to standard
            .replace("”", '"')               # smart double quote to standard
            .replace("•", "*")               # bullet point to asterisk
        )

        # Catch-all: force the string into latin-1, ignoring any remaining unsupported characters
        summary_text = summary_text.encode("latin-1", "ignore").decode("latin-1")
        # -----------------------------------------------------

        # 5. Create a new PDF with the summary
        pdf = FPDF()
        pdf.add_page()
        pdf.set_font("helvetica", size=12)

        # Adding a simple title
        pdf.set_font("helvetica", style="B", size=16)
        pdf.cell(0, 10, "CV Analysis Summary", new_x="LMARGIN", new_y="NEXT", align="C")
        pdf.ln(10)

        # Adding the summary body
        pdf.set_font("helvetica", size=12)
        pdf.multi_cell(0, 10, summary_text)

        pdf.output(temp_out_pdf)

        # 6. Upload the new PDF to the Output Bucket
        output_bucket_name = os.environ.get("OUTPUT_BUCKET")
        if not output_bucket_name:
            raise ValueError("OUTPUT_BUCKET environment variable is not set.")

        output_bucket = storage_client.bucket(output_bucket_name)
        output_blob = output_bucket.blob(f"summary_{file_name}")
        output_blob.upload_from_filename(temp_out_pdf)

        print(f"Successfully uploaded summary to {output_bucket_name}/summary_{file_name}")

    except Exception as e:
        print(f"An error occurred while processing {file_name}: {str(e)}")
        raise e

    finally:
        # 7. Cleanup temporary files to prevent memory leaks
        if os.path.exists(temp_local_pdf):
            os.remove(temp_local_pdf)
        if os.path.exists(temp_out_pdf):
            os.remove(temp_out_pdf)
