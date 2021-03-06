require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /\A[a-zA-Z0-9]{2,10}*\z/
  @@station_list = []

  validate :name, :presence

  attr_accessor :name, :trains

  class << self
    def all
      @@station_list
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@station_list << self
    register_instance
  end

  def each_train(&block)
    @trains.each(&block)
  end

  def show_all_trains
    @@station_list.each { |train| puts "Train number: #{train.number}, train type: #{train.type}, train carriages: #{train.carria}" }
  end

  def trains_type
    @trains.each { |train| puts "#{train.type} - #{train.number}" }
  end

  def get_train(train)
    @trains.push(train)
  end

  def send_train(train)
    @trains[train.type.to_sym].delete(train)
  end

  # protected

  # def validate!
  #   raise 'Station name should be longer that two characters' if name.length < 2
  #   raise 'Station name must consist of letters.' if name !~ NAME_FORMAT
  # end
end
