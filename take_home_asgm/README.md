# take_home_asgm
This is a simple Order Management Application using Flutter. No data persistence is used. Only Flutter Provider is  implemented to manage and serve the state of the application.

## Completed Tasks

✅ Flutter Project Setup  
✅ Core Functionality  
✅ User Interface
✅ End to end tests


### Core Functionality
1. Adding an order (Normal order or VIP order)
2. Organizing priority queue for the orders
3. Adding and removing bots
4. Automate the bots to process the orders. Order will be completed after 10 seconds assigned to the bot.
5. Interupt the process if the bot is removed

### User Interface
1. Bots information list
2. Pending orders information list
3. Completed orders information list

### End to end tests
1. Queue order
    - All the orders in the queue will be organized. First In First Out (FIFO) is implemented on the normal orders and VIP orders. However, the VIP orders will be priority to be processed.
2.  Bots processing
    - All bots will be processing the orders as long as there are still PENDING orders. If the bot is removed, the process will be interrupted.
    - The order will be completed after 10 seconds assigned to the bot.
    - The bots implement First In First Out (FIFO) as well, the first entered bot will be processing the order first.