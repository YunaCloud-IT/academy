import {Injectable} from '@nestjs/common';
import { CoffeeMachine } from "./interfaces";

@Injectable()
export class AppService {
  getCoffee(): string[] {
    return ['Espresso', 'Latte', 'Cappuccino', 'Americano'];
  }

  getMachines(): CoffeeMachine[] {
    return [
      { id: 1, name: 'La Marzocco Linea Mini', category: 'Manual' },
      { id: 2, name: 'Jura Z10', category: 'Automatic' },
      { id: 3, name: 'Nespresso Pixie', category: 'Pod' }
    ];
  }

  getCoffeeMachinesCategories(): string[] {
    return ['Manual', 'Automatic', 'Pod'];
  }
}
