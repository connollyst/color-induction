function log(message, varargin)
%LOG Log messages, if logging is enabled.
%   Prints the message if logging is enabled, with or without args.
%   
%   log('hello world', config) displays 'hello world' if
%   config.display.logging=1
%   
%   log('hello %s', 'world', config) displays 'hello world' if
%   config.display.logging=1
%   Note: fprintf() is used when extra arguments are provided, refer to
%   it's documentation for more details.
%
%   If config.display.logging is not specified, logging defaults to off.

    config = get_config(varargin{:});
    args   = get_args(varargin{:});
    if should_log(config)
        if isempty(args)
            disp(message);
        else
            fprintf(message, args);
        end
    end
end

function config = get_config(varargin)
    if isempty(varargin)
        error('expected config struct array for logging');
    end
    config = varargin{length(varargin)};
    if ~isstruct(config)
        error('expected config struct array as last arg')
    end
    if ~isfield(config, 'display')
        error('expected config.display to be defined');
    end
end

function message_args = get_args(varargin)
    message_args = [varargin{1:length(varargin)-1}];
end

function do_log = should_log(config)
    do_log = isfield(config.display, 'logging') && config.display.logging;
end