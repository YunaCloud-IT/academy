# -------------------------------------------------------------------
# STAGE 1: Build the binary
# -------------------------------------------------------------------
FROM golang:1.23 as builder

WORKDIR /app

# Retrieve application dependencies.
COPY go.* ./
RUN go mod download

COPY . .

# Build the binary.
# 1. CGO_ENABLED=0: Creates a static binary (no external C libraries).
# 2. GOOS=linux: Compiles for Linux.
# 3. GOARCH=amd64: Compiles specifically for Cloud Run architecture (Intel/AMD),
#    ensuring it works even if you build on an Apple M1/M2 chip.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o server

# -------------------------------------------------------------------
# STAGE 2: Create the final production image
# -------------------------------------------------------------------
# Use Alpine for a small footprint, but explicitly request the amd64 platform
# to match the binary we just built.
FROM --platform=linux/amd64 alpine:latest

# Install CA certificates to enable HTTPS calls to other services
RUN apk add --no-cache ca-certificates

# Copy the binary from the builder stage
COPY --from=builder /app/server /server

# Cloud Run injects the PORT environment variable
ENV PORT=8080
EXPOSE 8080

# Run the web service
CMD ["/server"]
