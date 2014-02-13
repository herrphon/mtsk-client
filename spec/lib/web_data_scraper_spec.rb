

require 'web_data_scraper'


describe Sprit_Monitor do
  it "should parse the js data into a data object" do
    js_source = "\n            <!--\n                var spmResult = " +
                "[{\"mtsk_id\":\"51D4B432A0951AA0E10080009459E03A\"," +
                "\"name\":\"JET KARLSRUHE KILLISFELDSTR. 32\",\"marke\":\"JET\"," + 
                "\"laengengrad\":\"8.45645\",\"breitengrad\":\"48.997\"," +
                "\"strasse\":\"KILLISFELDSTR. 32\",\"hausnr\":\"\"," + 
                "\"plz\":\"76227\",\"ort\":\"KARLSRUHE\"," +
                "\"datum\":\"2013-10-28 16:41:37\",\"e5\":\"1.479\","+
                "\"entfernung\":\"1.62\"}];\n                var MySpmConfig " +
                "= new SpmConfig(\"e5\", 48.9881, 8.47434, 2, \"http://www." + 
                "spritpreismonitor.de/\", false, \"28.10.13 18:03:12\");\n" + 
                "            -->\n            "
    data = Sprit_Monitor.get_data_from_js_source(js_source)
  
    data['e5'].should eq '1.479'
  end
end

