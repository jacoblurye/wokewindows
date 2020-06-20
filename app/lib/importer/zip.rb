class Importer::Zip < Importer::Importer
  SLICE = 1000

  def self.import_all
    parser = Parser::Zip.new("data/zipcode.csv")
    new(parser).import
  end

  def import
    records.each_slice(SLICE) do |slice|
      ZipCode.transaction do
        slice.each { |record| import_record(record) }
      end
    end
  end

  def import_record(record)
    ZipCode.create({
      zip: record[:zip],
      city: record[:city],
      state: record[:state],
      latitude: record[:latitude],
      longitude: record[:longitude]
    })
  rescue ActiveRecord::RecordNotUnique
    # ignore
  end
end
