function data = cells(config)
%CELL A utility function for creating a cell array, initialized with
%     matrices of zeros, sized appropriately for our model configuration.
    data = cell(config.zli.n_membr, 1);
    for t=1:length(data)
        data{t} = model.utils.zeros(config);
    end
end