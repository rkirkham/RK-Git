Feature: Edit an order in EOCS
	As a Nisa user,
	I want to edit an order in EOCS,
	So that a member's order is correct

@orderentry
Scenario: Valid Product
	Given I have entered a product number '123456'
		And the product number '123456' exists in the product file
		And the product number '123456' is not in the blacklisted file
		And the product number '123456' matches the specified scheme
		And the quantity is greater than zero
	When I add the product to the order
	Then an order line is added

	
Scenario: Reject Non-Existing product
	Given I have entered a product number '123456'
		And the product number '123456' does not exist in the product file
	When I add the product to the order
	Then an order line is not added
		And an error message is displayed

		
Scenario: Reject blacklisted product
	Given I have entered a product number '123456'
		And the product number '123456' exists in the product file
		And the product number '123456' is exists in the blacklisted file
	When I add the product to the order
	Then an order line is not added
		And an error message is displayed

		
Scenario Outline: Reject Wrong Scheme
	Given I am editing an order with scheme <order scheme>
		And I have entered a product with a scheme <product scheme>
	When I add the product to the order
	Then the outcome should be <outcome>
	Examples:
	| order scheme	| product scheme	| outcome	|
	| way			| freeze & chill	| rejected	|
	| freeze & chill	| way			| rejected	|


Scenario: Reject invalid quantity
	Given I have entered a quantity '0'
	When I add the product to the order
	Then an order line is not added to the order
		And an error message is displayed

		
Scenario: Create order
	Given I have added products to an order 
		And the order does not exist on the system
	When I  submit the order
	Then an order will be added to the system


Scenario: Delete product from order
	Given I am editing an existing order '0001'
	When I delete a product '123456'
	Then the product '123456' will be removed from the order '0001'


Scenario: Update quantity of product
	Given I am editing an existing order '0001'
	When I delete a product '123456'
	Then the product '123456' will be removed from the order '0001'


Scenario: Reject invalid edited quantity
	Given I am editing an existing order '0001'
		And the order has product '123456'
		And product '123456' has quantity '1'
		And I amend the quantity to '0'
	When I leave the field
	Then the product '123456' in order '0001' will have quantity '1'
		And an error message will be displayed


Scenario: Order summary
	Given an order with order lines
	| product id	| quantity	|
	| 123456		| 5			|
	| 000001		| 2			|
	| 000002		| 5			|
	Then the summary table will return
	| Total Products	| Total Cases	|
	| 3				| 12			|