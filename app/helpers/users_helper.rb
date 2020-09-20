# frozen_string_literal: true

module UsersHelper
    def active_button(path)
        return request.original_fullpath == path ||
               request.original_fullpath.include?(path + '?')
    end
end
