module HyoneSourcePackage
  module Helper

    def user_home(user)
      case user
      when 'root' then '/root'
      else File.join('/home', user)
      end
    end

  end
end

