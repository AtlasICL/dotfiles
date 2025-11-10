require "config.config_default"
require "config.config_override"
if not vim.g.config_default then
    require "config.lazy"
    require "config.options"
end
