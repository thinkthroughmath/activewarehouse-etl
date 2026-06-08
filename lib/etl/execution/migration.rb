module ETL #:nodoc:
  module Execution #:nodoc
    # Handles migration of tables required for persistent storage of meta data
    # for the ETL engine
    class Migration
      class << self
        protected
        # Get the schema info table name. Rails 7+ removed the class method
        # ActiveRecord::Migrator.schema_migrations_table_name; the value lives
        # on the connection's schema_migration object.
        def schema_info_table_name
          connection.schema_migration.table_name
        end
        alias :schema_migrations_table_name :schema_info_table_name

        public
        # Execute the migrations. Engine.init has already established the
        # etl_execution connection. Rails 7.1 made SchemaMigration per-connection;
        # use the connection's schema_migration to create/track versions.
        def migrate
          schema_migration = connection.schema_migration
          schema_migration.create_table unless schema_migration.table_exists?
          last_migration.upto(target - 1) do |i|
            __send__("migration_#{i+1}".to_sym)
            schema_migration.create_version(i + 1)
          end
        end

        protected
        def last_migration
          connection.select_values(
            "SELECT version FROM #{schema_migrations_table_name}"
          ).map(&:to_i).sort.last || 0
        end

        # Get the connection to use during migration. Don't memoize — connection
        # objects are checked back into the pool, and a stale @connection will
        # throw "connection is closed" after Rails reaps it.
        def connection
          ETL::Execution::Base.connection
        end

        # Get the final target version number
        def target
          4
        end

        private
        def migration_1 #:nodoc:
          connection.create_table :jobs do |t|
            t.column :control_file, :string, :null => false
            t.column :created_at, :datetime, :null => false
            t.column :completed_at, :datetime
            t.column :status, :string
          end
          connection.create_table :records do |t|
            t.column :control_file, :string, :null => false
            t.column :natural_key, :string, :null => false
            t.column :crc, :string, :null => false
            t.column :job_id, :integer, :null => false
          end
        end

        def migration_2 #:nodoc:
          connection.add_index :records, :control_file
          connection.add_index :records, :natural_key
          connection.add_index :records, :job_id
        end

        def migration_3 #:nodoc:
          connection.create_table :batches do |t|
            t.column :batch_file, :string, :null => false
            t.column :created_at, :datetime, :null => false
            t.column :completed_at, :datetime
            t.column :status, :string
          end
          connection.add_column :jobs, :batch_id, :integer
          connection.add_index :jobs, :batch_id
        end

        def migration_4
          connection.drop_table :records
        end

        def migration_5
          connection.add_column :batches, :batch_id, :integer
          connection.add_index :batches, :batch_id
        end

        # Update the schema info table, setting the version value
        def update_schema_info(version)
          connection.update("UPDATE #{schema_info_table_name} SET version = #{version}")
        end
      end
    end
  end
end
