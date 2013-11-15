module Spigot
  class ApiData

    def self.basic_user
      {full_name: 'Dean Martin', login: 'classyasfuck'}
    end

    def self.user
      {full_name: 'Dean Martin', login: 'classyasfuck', auth_token: '123abc'}
    end

    def self.basic_post
      {title: 'Brief Article', body: 'lorem ipsum'}
    end

    def self.post
      {title: 'Regular Article', body: 'dolor sit amet', author: 'Dean Martin'}
    end

  end
end
