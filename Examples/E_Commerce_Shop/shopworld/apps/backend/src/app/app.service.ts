import {Injectable} from '@nestjs/common';
import { CoffeeMachine } from "./interfaces";

@Injectable()
export class AppService {
  private machines: CoffeeMachine[] = [
    { id: 1, name: 'La Marzocco Linea Mini', category: 'Manual' },
    { id: 2, name: 'Jura Z10', category: 'Automatic' },
    { id: 3, name: 'Nespresso Pixie', category: 'Pod' },
    { id: 4, name: 'Rocket Espresso Appartamento', category: 'Manual' },
    { id: 5, name: 'DeLonghi Magnifica S', category: 'Automatic' },
    { id: 6, name: 'Keurig K-Elite', category: 'Pod' },
  ];

  getCoffee(): string[] {
    return [
      'Espresso',
      'Latte',
      'Cappuccino',
      'Americano',
      'Macchiato',
      'Mocha',
      'Flat White',
      'Cortado',
      'Affogato',
    ];
  }

  getMachines(): CoffeeMachine[] {
    return this.machines;
  }

  addMachine(machine: Omit<CoffeeMachine, 'id'>): CoffeeMachine {
    const newMachine = {
      ...machine,
      id: this.machines.length > 0 ? Math.max(...this.machines.map((m) => m.id)) + 1 : 1,
    };
    this.machines.push(newMachine);
    return newMachine;
  }

  deleteMachine(id: number): boolean {
    const initialLength = this.machines.length;
    this.machines = this.machines.filter((m) => m.id !== id);
    return this.machines.length < initialLength;
  }

  getCoffeeMachinesCategories(): string[] {
    return ['Manual', 'Automatic', 'Pod'];
  }

  getCoffeeCompanies(): string[] {
    return [
      'Starbucks',
      'Nespresso',
      'Lavazza',
      'Peet\'s Coffee',
      'Illy',
      'Stumptown',
      'Blue Bottle Coffee',
      'Intelligentsia',
    ];
  }

  getBrewingMethods(): string[] {
    return ['Drip', 'French Press', 'Pour Over', 'Cold Brew', 'AeroPress', 'Moka Pot'];
  }
}
