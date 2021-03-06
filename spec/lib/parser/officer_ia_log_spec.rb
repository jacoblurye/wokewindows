describe Parser::OfficerIaLog do
  let(:file) { file_fixture("sample_officer_ia_log.csv") }
  let(:parser) { Parser::OfficerIaLog.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.first
    expect(r[:ia_no]).to eql("IAD2014-0467")
    expect(r[:date_received]).to eql("24-Sep-14")
    expect(r[:date_occurred]).to eql("2-Sep-14")
    expect(r[:involved_officers]).to eql("Unknown officer")
    expect(r[:allegations]).to eql("Use of Force")
    expect(r[:summary]).to match(/^The complain.*East/)
    expect(r[:incident_type]).to eql("Citizen complaint")
    expect(r[:completed_date]).to eql("")
  end

  it "attribution" do
    expect(attribution.filename).to eql("sample_officer_ia_log.csv")
    expect(attribution.category).to eql("2014_officer_ia_log")
    expect(attribution.url).to eql(nil)
  end
end
