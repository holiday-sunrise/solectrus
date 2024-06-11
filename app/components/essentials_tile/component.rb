class EssentialsTile::Component < ViewComponent::Base
  def initialize(calculator:, sensor:, timeframe:)
    super
    @calculator = calculator
    @sensor = sensor.to_sym
    @timeframe = timeframe
  end

  attr_reader :calculator, :sensor, :timeframe

  def path
    if sensor.in? %i[savings]
      # Currently, there is no chart for savings, so link to inverter_power chart
      root_path(sensor: 'inverter_power', timeframe:)
    else
      root_path(sensor:, timeframe:)
    end
  end

  def value
    @value ||= calculator.public_send(sensor)
  end

  def color
    return :gray if value.nil? || value.round.zero?

    case sensor
    when :savings, :co2_reduction
      :blue
    when :house_power
      :gray
    else
      :green
    end
  end

  def background_color
    BACKGROUND_COLOR[color]
  end

  def text_primary_color
    TEXT_PRIMARY_COLOR
  end

  def text_secondary_color
    TEXT_SECONDARY_COLOR[color]
  end

  ICONS = {
    grid_export_power: 'fa-bolt',
    grid_import_power: 'fa-bolt',
    inverter_power: 'fa-sun',
    house_power: 'fa-home',
    wallbox_power: 'fa-car',
    savings: 'fa-piggy-bank',
    co2_reduction: 'fa-leaf',
    battery_soc: 'fa-battery-half',
  }.freeze

  BACKGROUND_COLOR = {
    green: 'bg-green-600',
    yellow: 'bg-yellow-600',
    red: 'bg-red-600',
    gray: 'bg-gray-600',
    blue: 'bg-blue-600',
  }.freeze

  TEXT_PRIMARY_COLOR = 'text-white'.freeze

  TEXT_SECONDARY_COLOR = {
    green: 'text-green-100',
    yellow: 'text-yellow-100',
    red: 'text-red-100',
    gray: 'text-gray-100',
    blue: 'text-blue-100',
  }.freeze

  private_constant :BACKGROUND_COLOR
  private_constant :TEXT_PRIMARY_COLOR
  private_constant :TEXT_SECONDARY_COLOR
  private_constant :ICONS

  def icon_class
    ICONS[sensor]
  end

  def title
    case sensor
    when :savings
      t("calculator.#{sensor}")
    when :co2_reduction
      t('calculator.co2_reduction_note')
    else
      t("sensors.#{sensor}")
    end
  end

  def formatted_value
    return '---' unless value

    number = Number::Component.new(value:)
    case sensor
    when :savings
      number.to_eur(klass: 'text-inherit')
    when :co2_reduction
      number.to_weight
    when :autarky, :battery_soc
      number.to_percent(klass: 'text-inherit')
    else
      timeframe.now? ? number.to_watt : number.to_watt_hour
    end
  end

  def refresh_interval
    [
      interval_by_timeframe,
      Rails.configuration.x.influx.poll_interval.seconds,
    ].max
  end

  def interval_by_timeframe
    if timeframe.now?
      5.seconds
    elsif timeframe.day?
      1.minute
    elsif timeframe.week?
      5.minutes
    elsif timeframe.month?
      10.minutes
    elsif timeframe.year?
      1.hour
    else
      1.day
    end
  end
end
