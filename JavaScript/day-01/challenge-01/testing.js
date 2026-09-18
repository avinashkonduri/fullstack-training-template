
function getUserProfile() {
  // 1. Declare variables before using them to prevent TDZ errors
  let role = "Admin";

  // 2. Declare function expressions before invocation
  const getBadge = function() {
    return `User (${role}) access granted: ${getPrefix()}`;
  };

  function getPrefix() {
    return "SECURE"; // Function declarations are fully hoisted
  }

  // 3. Log values after initialization
  console.log("Role:", role);
  console.log(getBadge());
}

getUserProfile();

function createBankAccount(initialBalance = 0) {
  // Private state closed over by inner methods
  let balance = initialBalance;
  const transactions = [];

  return {
    deposit(amount) {
      if (amount <= 0) return "Invalid deposit amount";
      balance += amount;
      transactions.push({ type: 'deposit', amount });
      return balance;
    },

    withdraw(amount) {
      if (amount > balance) return "Insufficient funds";
      balance -= amount;
      transactions.push({ type: 'withdraw', amount });
      return balance;
    },

    getStatement() {
      // Return a shallow copy of transactions to prevent external modification
      return {
        balance,
        transactions: [...transactions]
      };
    }
  };
}

// Example usage:
const myAccount = createBankAccount(100);
myAccount.deposit(50);
myAccount.withdraw(30);

console.log(myAccount.getStatement());
// Output: { balance: 120, transactions: [ { type: 'deposit', amount: 50 }, { type: 'withdraw', amount: 30 } ] }
console.log(myAccount.balance); // Output: undefined

function formatInventory(products, taxRate) {
  return products.map(item => {
    const taxAmount = item.price * taxRate;
    const total = item.price + taxAmount;

    return {
      ...item, // Spread original properties
      taxAmount: taxAmount,
      formattedTotal: `$${total.toFixed(2)}`
    };
  });
}

// Example usage:
const rawProducts = [
  { name: "Laptop", price: 1000 },
  { name: "Mouse", price: 25 }
];

console.log(formatInventory(rawProducts, 0.10));
// Output:
// [
//   { name: 'Laptop', price: 1000, taxAmount: 100, formattedTotal: '$1100.00' },
//   { name: 'Mouse', price: 25, taxAmount: 2.5, formattedTotal: '$27.50' }
// ]


function filterEligibleEmployees(employeeList) {
  return employeeList.filter(emp => {
    const isActive = emp.isActive === true;
    const hasEnoughService = emp.yearsOfService >= 2;
    const meetsPerformance = emp.rating > 4.0 || emp.projectsCompleted >= 5;

    return isActive && hasEnoughService && meetsPerformance;
  });
}

// Example usage:
const employees = [
  { id: 1, name: "Alice", isActive: true, yearsOfService: 3, rating: 4.5, projectsCompleted: 2 },
  { id: 2, name: "Bob", isActive: true, yearsOfService: 1, rating: 4.8, projectsCompleted: 6 },
  { id: 3, name: "Charlie", isActive: false, yearsOfService: 5, rating: 4.2, projectsCompleted: 10 },
  { id: 4, name: "Diana", isActive: true, yearsOfService: 4, rating: 3.8, projectsCompleted: 5 }
];

console.log(filterEligibleEmployees(employees));
// Output: [ Alice object, Diana object ]

function getUrgentTicket(queue) {
  const urgentTicket = queue.find(
    ticket => ticket.status === "open" && ticket.priority === "CRITICAL"
  );

  return urgentTicket || "No urgent tickets found";
}

// Example usage:
const ticketQueue = [
  { id: "T-101", priority: "LOW", status: "open" },
  { id: "T-102", priority: "CRITICAL", status: "closed" },
  { id: "T-103", priority: "CRITICAL", status: "open" },
  { id: "T-104", priority: "CRITICAL", status: "open" }
];

console.log(getUrgentTicket(ticketQueue));
// Output: { id: 'T-103', priority: 'CRITICAL', status: 'open' }


function calculateFinalTotal(prices, discount) {
  // 1. Initialize a running total variable
  let total = 0;

  // 2. Loop through array to sum all prices
  for (let i = 0; i < prices.length; i++) {
    total += prices[i];
  }

  // 3. Apply discount if total is over 100 using operators
  if (total > 100) {
    const discountAmount = (total * discount) / 100;
    return total - discountAmount;
  }

  // 4. Return regular total if 100 or under
  return total;
}

// --- Testing with Sample Data ---
console.log(calculateFinalTotal([25, 50, 75], 10)); // Output: 135 (Total 150 - 10% discount)
console.log(calculateFinalTotal([20, 15, 45], 15)); // Output: 80 (Total under 100, no discount)

function getEvenNumbers(numbers) {
  // 1. Create a new empty array variable for even numbers
  const evenNumbers = [];

  // 2. Loop through the input array
  for (let i = 0; i < numbers.length; i++) {
    // 3. Use modulo operator (%) and strict equality (===) to check if even
    if (numbers[i] % 2 === 0) {
      // 4. Push matching number into the new array
      evenNumbers.push(numbers[i]);
    }
  }

  // 5. Return the populated array
  return evenNumbers;
}

// --- Testing with Sample Data ---
console.log(getEvenNumbers([1, 2, 3, 4, 5, 6])); // Output: [2, 4, 6]
console.log(getEvenNumbers([11, 23, 45]));       // Output: []
console.log(getEvenNumbers([-4, 0, 7, 14]));      // Output: [-4, 0, 14]