import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { CoffeeMachine } from './interfaces';

@Controller("products")
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get("coffee")
  getCoffee() {
    return this.appService.getCoffee();
  }

  @Get("coffee-machines")
  getMachines() {
    return this.appService.getMachines();
  }

  @Post("coffee-machines")
  addMachine(@Body() machine: Omit<CoffeeMachine, 'id'>) {
    return this.appService.addMachine(machine);
  }

  @Delete("coffee-machines/:id")
  deleteMachine(@Param("id") id: string) {
    return this.appService.deleteMachine(+id);
  }

  @Get("coffee-machine-categories")
  getCoffeeMachinesCategories() {
    return this.appService.getCoffeeMachinesCategories();
  }

  @Get("coffee-companies")
  getCoffeeCompanies() {
    return this.appService.getCoffeeCompanies();
  }

  @Get("brewing-methods")
  getBrewingMethods() {
    return this.appService.getBrewingMethods();
  }
}
