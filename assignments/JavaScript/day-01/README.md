Question 1: The Shopping Cart Calculator

Problem Statement:
Write a function named calculateFinalTotal that takes an array of item prices and a discount percentage. The function should calculate the total sum of all items, apply the discount if the total is over $100, and return the final price.Requirements:Function: Create a function calculateFinalTotal(prices, discount)Variables: Use let or const to store your running total and final price.Loop: Use a for loop to iterate through the prices array and add each item to the total.Operators: Use addition (+=) to sum the prices, comparison (>) to check if the total exceeds 100, and math operators (*, -) to calculate the discount.Arrays: The prices parameter will be an array of numbers.
Example Input & Output:JavaScript// 

// Test 1: Total is exactly 100 (Threshold test - should it get a discount?)
const cart1 = [25, 25, 50];
const discount1 = 10;
// Expected output: 100 (or 90, depending on if you used > 100 or >= 100)

// Test 2: Large total with a high discount
const cart2 = [120, 45, 35, 100];
const discount2 = 25;
// Expected output: 225 (Total is 300. 25% of 300 is 75. 300 - 75 = 225)

// Test 3: Empty cart
const cart3 = [];
const discount3 = 15;
// Expected output: 0 

// Test 4: Small items, no discount applied
const cart4 = [5, 12, 8, 3];
const discount4 = 20;
// Expected output: 28

Question 2: The Even Number Extractor
Problem Statement:
Write a function named getEvenNumbers that takes an array of random integers and returns a brand new array containing only the even numbers from the original list.Requirements:Function: Create a function getEvenNumbers(numbers)Variables: Create an empty array variable inside the function to hold the even numbers.Loop: Use a for or while loop to check every single item in the input array.Operators: Use the modulo operator (%) and strict equality (===) to determine if a number is even (leaves a remainder of 0 when divided by 2).Arrays: Use the .push() method to add qualifying numbers to your new array, and return that new array at the end.
Example Input & Output:JavaScript// 

// Test 1: Mixed positive integers
const mixedNumbers = [12, 17, 8, 9, 24, 33];
// Expected output: [12, 8, 24]

// Test 2: Only odd numbers 
const oddNumbers = [7, 13, 99, 101, 3];
// Expected output: []

// Test 3: Only even numbers
const allEvens = [2, 4, 6, 8, 10];
// Expected output: [2, 4, 6, 8, 10]

// Test 4: Including zero and negative numbers
const trickyNumbers = [-4, -3, 0, 7, 14, -9];
// Expected output: [-4, 0, 14] (Zero and -4 are considered even!)
