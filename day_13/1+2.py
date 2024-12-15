from dataclasses import dataclass
from sympy import symbols, Eq, solve
from typing import List, Optional

a, b = symbols('a b', integer=True)

modificator_2 = 10000000000000

@dataclass
class Position:
    x: int
    y: int

@dataclass
class Button:
    x: int
    y: int
    cost: int

@dataclass
class ClawMachine:
    a: Button
    b: Button
    prize: Position

    def define_direction_eq(self, var_name: str) -> Eq:

        a_value = getattr(self.a, var_name)
        b_value = getattr(self.b, var_name)
        prize_value = getattr(self.prize, var_name)

        return Eq(a_value * a + b_value * b, prize_value)

    def calculate_total_cost(self) -> Optional[int]:
        eqY = self.define_direction_eq("y")
        eqX = self.define_direction_eq("x") 
        solution = solve((eqY, eqX), (a, b))
        if not solution:
            return None
        cost_a = solution[a]* self.a.cost
        cost_b = solution[b]* self.b.cost
        return cost_a  + cost_b

def parse_file(file_path: str, mod:int = 0) -> List[ClawMachine]:
    machines = []

    with open(file_path, 'r') as file:
        input_data = file.read().strip()

    machine_configs = input_data.split("\n\n")

    for config in machine_configs:
        lines = config.split("\n")
        

        button_a_data = lines[0].split(":")[1].strip()
        dx_a, dy_a = map(int, [s[1:] for s in button_a_data.split(", ")])
        
        button_b_data = lines[1].split(":")[1].strip()
        dx_b, dy_b = map(int, [s[1:] for s in button_b_data.split(", ")])
        
        prize_data = lines[2].split(":")[1].strip()
        x_prize, y_prize = map(int, [s[2:] for s in prize_data.split(", ")])
        
        button_a = Button(x=dx_a, y=dy_a, cost=3)
        button_b = Button(x=dx_b, y=dy_b, cost=1)
        prize = Position(x=x_prize+mod, y=y_prize+mod)
        

        machine = ClawMachine(a=button_a, b=button_b, prize=prize)
        machines.append(machine)

    return machines



def main():
    ttotal_cost = 0
    #use mod =modificator_2 to solve part 2
    machines = parse_file("input.txt")

    for machine in machines: 
        total_cost = machine.calculate_total_cost()
        if total_cost:
            ttotal_cost += total_cost

    print(f"this is total cost {ttotal_cost}")

if __name__ == "__main__":
    main()
