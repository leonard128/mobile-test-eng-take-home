# Quality Engineering Documentation

## 1. Tool Selection: Maestro

Maestro was chosen as champion testing framework for these key reasons:

- **Simplicity**: Maestro offers a straightforward YAML-based syntax that makes tests readable and maintainable
- **Cross-platform**: Seamlessly works on both iOS and Android with the same test scripts. Also since we're using React Native so maestro will be easier to use than appium

Appium could take forever to setup lol, Maestro's simplicity and easy to start fits better here(since we only have 4 pages in the app so it's really a no brainer).

## 2. Test Organizing/Prioritizing Strategy

Our approach to test Organizing/Prioritizing focuses on:
- **From platform perspective:**
    - **Cross-platform validation**: Ensuring consistent behavior across iOS and Android(since we're using react native so most of the behavior will be the same)
    - **Platform-specific checks**: Targeting Platform-Specific UI Elements rendering and behavior

- **From test priority perspective:**
    - **Smoke testing**: Quick validation of critical app functionality(P0 tests that could be used to block the PRs)
    - **Happy path**: Ensuring core user flows work as expected under normal conditions
    - **Edge case handling**: Including tests for boundary conditions and error states

React native is good at creating unified UI components across iOS/Android but there's always platorm-Specific UI elements that might be utilized.

## 3. Maintainability and Expandability

To ensure our test suite remains maintainable and scalable:

- **Page object model pattern**: UI elements are defined in page files to minimize duplication and ease of maintenance/expandability
- **Modular test structure**: Core functions are implimented separately that can be reused to keep the test runs rational and easier to debug
- **Test priority**: Tests are assigned priorities based on their impact
- **Test organization**: Tests are categorized and grouped logically
- **Parameterization**: Tests accept variables from pre-designed test data file to enhance flexibility and adaptability
- **Test data management**: Test data is stored in separate files for easy updates
- **Documentation**: Each test includes purpose and expected outcomes

This GOLDEN RULE allows new tests to be added with minimal effort and existing tests to be updated efficiently.

## 4. Test Reporting

Our reporting strategy includes:

- **Test summary**: Overview of test execution status
- **Test metrics**: Key performance indicators for test effectiveness(this could includes test coverage percentage/health score trend)
- **Structured results**: Test results are formatted for easy interpretation
- **Healthy score**: Failure are meassured according to the test case priority and health score is calculated according to the pass/fail ratio
- **Historical tracking**: Maintaining records of test performance over time

Just a common reporting system, no fancy stuff here. But we can always trim down the report to make it more readable.

## 5. Continuous Integration

We've implemented automated test execution on pull requests:

- **GitHub Actions workflow**: Automatically triggers tests on PR creation/update
- **Status checks**: PRs require passing certain tests(maybe P0 tests) before merging
- **Notification system**: Team members can subscribe to test result and customize notifications to their preferences(I was told that I don't need to implement all the features so why not lol)

## 6. Directory Structure

```bash
~/.maestro/
├── 0-pages/
├── 1-useful_functions/
│   ├── core/
│   ├── utility/
│   └── system_handler/
├── 2-tests/
│   ├── smoke/
│   │   └── P0_features
│   │   └── static_page_elements
│   ├── nightly/
│   └── e2e/
├── 3-data/
└── 4-config/
```