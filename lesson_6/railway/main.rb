require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'carriage'
require_relative 'carriages/cargo_carriage'
require_relative 'carriages/passenger_carriage'
require_relative 'trains/cargo_trains'
require_relative 'trains/passenger_trains'
require_relative 'modules/company'
require_relative 'modules/instance_counter'

stations = []
trains = []

TRAIN_TYPES = { passenger: PassengerTrain, cargo: CargoTrain }.freeze
CARRIAGE_TYPES = { passenger: PassengerCarriage, cargo: CargoCarriage }.freeze

class Main
  def initialize
    @stations = []
    @trains = []
  end

  def menu
    loop do
      puts "Select an action:
  		      1. Create station.
  		      2. Create train.
  		      3. Attach carriage to the train.
  		      4. Detach carriage of the train.
  		      5. Put the train station.
  		      6. View a list of stations.
  		      7. View a list of the trains.
  		      8. Quit the program."
      choice = gets.chomp.to_i
      case choice
      when 1
        create_station
      when 2
        create_train
      when 3
        attach_carriage
      when 4
        detach_carriage
      when 5
        send_train
      when 6
        stations_list
      when 7
        trains_list
      when 8
        exit
      else
        puts 'Select the number action.'
      end
    end
  end

  private

  def attach_carriage
    if !@trains.empty?
      puts 'Choose train to attach: '
      @trains.each_with_index { |train, index| puts "#{index + 1}. #{train}" }
      choice = gets.chomp.to_i
      if choice <= @trains.size
        @trains[choice - 1].add_carriage(CARRIAGE_TYPES[@trains[choice - 1].type].new)
        puts 'Carriage attached'
      else
        puts 'Error. No Such train'
      end
    else
      puts 'Create any train at first'
    end
  end

  def detach_carriage
    unless @trains.empty?
      puts 'Choose train to detach: '
      @trains.each_with_index { |train, index| puts "#{index + 1}. #{train}" }
    end
    choice = gets.chomp.to_i

    if choice <= @trains.size
      @trains[choice - 1].delete_carriage
      puts 'Carriage detached'
    end
  end

  def send_train
    if !@trains.empty?
      puts 'Choose train to detach: '
      index = 0
      @trains.each do |value|
        index += 1
        puts "#{index}. #{value.type} - #{value.number}"
      end
    else
      puts 'Create a train.'
    end

    train_index = gets.chomp.to_i

    if !@stations.empty?
      puts 'Choose station: '
      index = 0
      @stations.each do |value|
        index += 1
        puts "#{index}. #{value.name}"
      end
    else
      puts 'Create a station!'
    end

    station_index = gets.chomp.to_i

    if station_index <= @stations.size
      @stations[station_index - 1].get_train(@trains[station_index - 1])
      puts 'Train move to the station'
    else
      puts 'No such station'
    end
  end

  def stations_list
    if !@stations.empty?
      @stations.each { |value| puts "Station: #{value.name}. Trains: #{value.trains_type}" }
    else
      puts 'No stations'
    end
  end

  def trains_list
    if !@trains.empty?
      @trains.each { |value| puts "Train: #{value.number}, type: #{value.type}" }
    else
      puts 'No trains'
    end
  end

  def create_station
    puts 'Enter the name of the station: '
    station = gets.chomp
    @stations << Station.new(station)
    puts "Station #{station} created"
  end

  def create_train
    puts "What type of train you want to create, passenger or cargo?
  	     1. Passenger
  	     2. Cargo"
    choice = gets.chomp.to_i

    train_type = case choice
                 when 1
                   :passenger
                 when 2
                   :cargo
    end

    puts 'Enter the train number: '
    train_number = gets.chomp.to_s
    train = TRAIN_TYPES[train_type.to_sym].new(train_number)
    @trains.push(train)
    puts "#{train_type.capitalize} train with number #{train_number} created."
  end
end

main = Main.new
main.menu
