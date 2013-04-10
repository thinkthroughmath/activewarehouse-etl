module ETL #:nodoc:
  module Control #:nodoc:
    class DatabaseScdRowFinder
      attr_reader :dimension_table, :natural_key, :scd_latest_version_field, :scd_type, :connection

      def initialize(dimension_table, natural_key, scd_latest_version_field, scd_type, connection)
        @dimension_table = dimension_table
        @natural_key = natural_key
        @scd_latest_version_field = scd_latest_version_field
        @scd_type = scd_type
        @connection = connection
      end

      # Find the version of this row that already exists in the datawarehouse.
      def find_preexisting_row(row)
        q = "SELECT * FROM #{dimension_table} WHERE #{natural_key_equality_for_row(row)}"
        q << " AND #{scd_latest_version_field}" if scd_type == 2

        result = connection.select_one(q)
      end

      private

      # Helper for generating the SQL where clause that allows searching
      # by a natural key
      def natural_key_equality_for_row(row)
        statement = []
        values = []
        natural_key.each do |nk|
          statement << "#{nk} = #{connection.quote(row[nk])}"
        end
        statement.join(" AND ")
      end
    end
  end
end
