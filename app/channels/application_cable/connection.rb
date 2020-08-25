# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user_id, :current_user
    

    def connect
      
      cu = find_verified_user
      self.current_user = cu
      self.user_id = cu.id
      puts "==========conntection==============="
    end

    private

    def find_verified_user # this checks whether a user is authenticated with devise
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
