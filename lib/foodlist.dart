class FoodList {
  final int id;
  final String name;
  final String foodCategory;

  FoodList({
    this.id = 0,
    this.name = '',
    this.foodCategory = '',

  });

  List<FoodList> foodList() {
    return [
      FoodList(
        id: 63129010,
        name: 'Mango',
        foodCategory: 'Fruit',

      ),
      FoodList(
        id: 1103528,
        name: 'Okra',
        foodCategory: 'Vegetable',

      ),
      FoodList(
        id: 75111000,
        name: 'Cucumber',
        foodCategory: 'Vegetable',

      ),
      FoodList(
        id: 74101000,
        name: 'Tomatoes',
        foodCategory: 'Vegetable',

      ),
      FoodList(
        id: 75101800,
        name: 'Green beans',
        foodCategory: 'Vegetable',

      ),


      FoodList(
        id: 1102653,
        name: 'Banana',
        foodCategory: 'Fruit',

      ),
      FoodList(
        id: 1102597,
        name: 'Orange',
        foodCategory: 'Fruit',

      ),
      FoodList(
        id: 1100534,
        name: 'Peanut',
        foodCategory: 'Nuts',

      ),
      FoodList(
        id: 1102702,
        name: 'Blueberries',
        foodCategory: 'Fruit',

      ),
      FoodList(
        id: 1102644,
        name: 'Apple',
        foodCategory: 'Fruit',

      ),
    ];
  }
}







