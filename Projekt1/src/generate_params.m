function params = generate_params()
    data = importdata('../data/params');
    rng(399);
    index = randi(30);
    params = data(index, :);
end

