from sympy import symbols, Eq, solve


n, m = symbols('n m', integer=True)

eq1 = Eq(94 * n + 22 * m, 8400)
eq2 = Eq(34 * n + 67 * m, 5400)

solution = solve((eq1, eq2), (n, m))

if solution:
    print(f"Solution: {solution}")
else:
    print("No solution exists.")
