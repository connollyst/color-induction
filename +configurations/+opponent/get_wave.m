function wave = get_wave()

    wave = configurations.defaults.get_wave();

    wave.transform = 'opponent';
    wave.n_orients = 4;
    
    % TODO add single/double opponent wavelet configuration
    
end