import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "PillInformation",
                          destinations: .iOS,
                          additionalTargets: ["PillInformationKit", "PillInformationUI"])
