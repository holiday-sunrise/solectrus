describe PowerTop10 do
  let(:measurement) { "Test#{described_class}" }

  let(:chart) { described_class.new(fields: ['inverter_power'], measurements: [measurement]) }

  let(:beginning) { 1.year.ago.beginning_of_year }

  before do
    (0..11).each do |index|
      add_influx_point name: measurement, fields: { inverter_power: (index + 1) * 1000 }, time: (beginning + index.month).end_of_month
      add_influx_point name: measurement, fields: { inverter_power: (index + 1) * 1000 }, time: (beginning + index.month).beginning_of_month
    end

    add_influx_point name: measurement, fields: { inverter_power: 14_000 }
  end

  around { |example| freeze_time(&example) }

  describe '#years' do
    subject { chart.years }

    it { is_expected.to have(1).items }
  end

  describe '#months' do
    subject { chart.months }

    it { is_expected.to have(2).items }
  end

  describe '#days' do
    subject { chart.days }

    it { is_expected.to have(3).items }
  end
end
