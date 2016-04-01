module Kernel
    alias orig_warn warn
    def warn args
        orig_warn args
        exit
    end
end
