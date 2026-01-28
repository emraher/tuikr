# Contributing to tuikR

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/tuikR.git`
3. Create a branch: `git checkout -b feature/your-feature-name`

## Development Workflow

### Setup

```r
# Install development dependencies
install.packages("devtools")
devtools::install_dev_deps()
```

### Making Changes

1. Write your code following the existing style
2. Document your functions with roxygen2 comments
3. Add tests for new functionality
4. Run checks locally:

```r
devtools::document()  # Update documentation
devtools::test()      # Run tests
devtools::check()     # Run R CMD check
```

### Code Style

- Use 2 spaces for indentation
- Follow the tidyverse style guide
- Keep lines under 120 characters

### Testing

- Add tests in `tests/testthat/`
- Use testthat edition 3 syntax
- Ensure all tests pass before submitting
- Network-dependent tests should use `skip_on_cran()` and `skip_if_offline()`

### Documentation

- Document all exported functions
- Include examples that run without errors
- Update NEWS.md for user-facing changes

## Submitting Changes

1. Ensure `devtools::check()` passes with no errors, warnings, or notes
2. Commit your changes with clear messages
3. Push to your fork
4. Open a pull request

## Questions?

Open an issue for any questions or discussions.
