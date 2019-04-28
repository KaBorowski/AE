function f = rosenbrock_function(x, y, a, b)

f = (1 - x + a).^2 + 100*(y - b - (x - a).^2).^2;

end

