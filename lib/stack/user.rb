require 'stax/aws/iam'

module Stax
  class User < Stack

    no_commands do
      def user_name
        @_user_name ||= stack_output(:IamUser)
      end

      def access_keys
        Aws::Iam.client.list_access_keys(user_name: user_name).access_key_metadata
      end

      def list_access_keys
        debug("Access keys for #{user_name}")
        print_table access_keys.map { |k| [k.access_key_id, k.status, k.create_date] }
      end

      def create_access_key
        debug("Creating access key for #{user_name}")
        print_table Aws::Iam.client.create_access_key(user_name: user_name).access_key.to_h
      end

      def delete_access_key(id)
        Aws::Iam.client.delete_access_key(user_name: user_name, access_key_id: id)
      end

      def delete_access_keys
        debug("Deleting all access keys for #{user_name}")
        access_keys.map(&:access_key_id).map(&method(:delete_access_key))
      end

      def rotate_access_keys
        delete_access_keys
        sleep 5                 # the lazy approach to eventual consistency
        create_access_key
      end
    end

    desc 'create', 'create stack'
    def create
      super
      create_access_key
    end

    desc 'access', 'handle access keys for user'
    method_option :create, aliases: '-c', type: :boolean, default: false, desc: 'create access key'
    method_option :delete, aliases: '-d', type: :boolean, default: false, desc: 'delete all access keys'
    method_option :rotate, aliases: '-r', type: :boolean, default: false, desc: 'rotate access keys'
    def access
      if options[:create]
        create_access_key
      elsif options[:delete]
        delete_access_keys
      elsif options[:rotate]
        rotate_access_keys
      else
        list_access_keys
      end
    end

  end
end