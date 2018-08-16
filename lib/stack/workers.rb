module Stax
  class Workers < Stack
    include Ecs, Logs

    no_commands do
      def ecs_cluster_name
        @_ecs_cluster_name ||= stack(:vpc).stack_output(:EcsCluster)
      end
    end

    desc 'stat', 'shortcut to various statuses'
    def stat
      invoke :ecs, [:tasks]
    end

  end
end