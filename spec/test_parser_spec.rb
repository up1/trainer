describe Trainer do
  describe Trainer::TestParser do
    describe "Loading a file" do
      it "raises an error if the file doesn't exist" do
        expect do
          Trainer::TestParser.new("notExistent")
        end.to raise_error(/File not found at path/)
      end

      it "raises an error if FormatVersion is not supported" do
        expect do
          Trainer::TestParser.new("spec/fixtures/InvalidVersionMismatch.plist")
        end.to raise_error("Format version '0.9' is not supported, must be 1.1, 1.2")
      end

      it "loads a file without throwing an error" do
        Trainer::TestParser.new("spec/fixtures/Valid1.plist")
      end
    end

    describe "#auto_convert" do
      it "raises an error if no files were found" do
        expect do
          Trainer::TestParser.auto_convert({ path: "bin" })
        end.to raise_error("No test result files found in directory 'bin', make sure the file name ends with 'TestSummaries.plist'")
      end
    end

    describe "Stores the data in a useful format" do
      describe "#tests_successful?" do
        it "returns false if tests failed" do
          tp = Trainer::TestParser.new("spec/fixtures/Valid1.plist")
          expect(tp.tests_successful?).to eq(false)
        end
      end

      it "works as expected" do
        tp = Trainer::TestParser.new("spec/fixtures/Valid1.plist")
        expect(tp.data).to eq([
                                {
                                  project_path: "Themoji.xcodeproj",
                                  target_name: "Unit",
                                  test_name: "Unit",
                                  tests: [
                                    {
                                      identifier: "Unit/testExample()",
                                      test_group: "Unit",
                                      name: "testExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "4A24BFED-03E6-4FBE-BC5E-2D80023C06B4"
                                    },
                                    {
                                      identifier: "Unit/testExample2()",
                                      test_group: "Unit",
                                      name: "testExample2()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Failure",
                                      guid: "B6AE5BAD-2F01-4D34-BEC8-6AB07472A13B",
                                      failures: [
                                        {
                                          file_name: "/Users/krausefx/Developer/themoji/Unit/Unit.swift",
                                          line_number: 34,
                                          message: "XCTAssertTrue failed - ",
                                          performance_failure: false,
                                          failure_message: "XCTAssertTrue failed - /Users/krausefx/Developer/themoji/Unit/Unit.swift:34"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "Unit/testPerformanceExample()",
                                      test_group: "Unit",
                                      name: "testPerformanceExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "777C5F98-023B-4F99-B98D-20DDE724160E"
                                    }
                                  ],
                                  number_of_tests: 3,
                                  number_of_failures: 1
                                }
                              ])
      end
    end
  end
end
