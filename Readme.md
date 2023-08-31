Traffic Light Controller |Verilog Project 

#Project description
This verilog project contolls the intersection of street "A" and street "B". Each street has traffic sensors, sa and sb for street A and B respectively, each sensor detects if there is a vehicle approaching or stopped at the intersection. Street A is the main street and it has green light at least 70 seconds, then it continues to be green unless there is a car at street B, then the light changes and street B has a green light for at least 50 seconds. Then if there is no vehicle on street A, street B continues to have a green light for extra 20 seconds. After that if there are still no vehicles in street A while steet B has ones, then street B continues to have green light until there are no vehicles in street B or street A has one.

The controller has 3 inputs clk, sa and sb. And it has 6 outputs GA,RA,YA driving lights on street "A" and GB,RB,YB diriving lights on street "B".