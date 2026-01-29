import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

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

  @Get("coffee-machine-categories")
  getCoffeeMachinesCategories() {
    return this.appService.getCoffeeMachinesCategories();
  }

  @Get("coffee-companies")
  getCoffeeCompanies() {
    return this.appService.getCoffeeCompanies();
  }
}
