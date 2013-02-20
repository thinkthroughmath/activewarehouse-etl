dw_conn = ETL::Engine.connection(:data_warehouse)
cached_people = dw_conn.select_all('SELECT * FROM person_dimension where latest_version = true')

source :in, {
  :file => "scd/#{ENV['run_number']}.txt",
  :parser => :csv
},
[
  :first_name,
  :last_name,
  :address,
  :city,
  :state,
  :zip_code
]

destination :out, {
  :type => :database,
  :target => :data_warehouse,
  :database => 'etl_unittest',
  :table => 'person_dimension',
  :natural_key => [:first_name, :last_name],
  :scd => {
    :type => 2,
    :dimension_target => :data_warehouse,
    :dimension_table => 'person_dimension',
    :row_finder => Proc.new do |row|
      cached_people.detect { |p|
        row[:first_name] == p['first_name'] && row[:last_name] == p['last_name']
      }
    end
  },
  :scd_fields => ENV['type_2_scd_fields'] ? Marshal.load(ENV['type_2_scd_fields']) : [:address, :city, :state, :zip_code]
},
{
  :order => [
    :id, :first_name, :last_name, :address, :city, :state, :zip_code, :effective_date, :end_date, :latest_version
  ],
  :virtual => {
    :id => ETL::Generator::SurrogateKeyGenerator.new(:target => :data_warehouse, :table => 'person_dimension')
  }
}

