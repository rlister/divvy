module Stax
  class Vpc < Stack

    no_commands do
      def cfn_parameters
        {
          cluster: "#{app_name}-#{branch_name}"
        }
      end
    end

  end
end