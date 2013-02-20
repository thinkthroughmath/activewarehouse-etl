module ETL #:nodoc:
  module Control #:nodoc:
    class ProcScdRowFinder
      attr_reader :row_proc

      def initialize(row_proc)
        @row_proc = row_proc
      end

      # Call the proc to try and find the row
      def find_preexisting_row(row)
        row_proc.call(row)
      end
    end
  end
end
