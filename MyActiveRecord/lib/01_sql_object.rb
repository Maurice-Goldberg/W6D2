require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns.nil?
      data = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL

      @columns = data[0].map(&:to_sym)
    else
      @columns
    end
  end

  def self.finalize!
    columns.each do |column_name|
      define_method(column_name) do
        self.attributes[column_name]
      end

      define_method("#{column_name}=") do |val|
        self.attributes[column_name] = val
      end
    end
    
  end

  def self.table_name=(table_name_arg)
    @table_name = table_name_arg
  end

  def self.table_name
    @table_name.nil? ? @table_name = self.to_s.tableize : @table_name
  end

  def self.all
    data = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL
    data = data.drop(1)

    data.map do |hash|
      self.class.new(hash)
    end
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |key, val|
      unless self.class.columns.include?(key)
        raise "unknown attribute '#{key}'"
      else
        self.send("#{key}=", val)
      end
    end
  end

  def attributes
    @attributes.nil? ? @attributes = {} : @attributes
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
