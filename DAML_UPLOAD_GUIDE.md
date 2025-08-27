# DAML Upload Guide for DServ Validator

This guide explains how to use the DAML upload functionality that automatically builds and uploads DAML packages to the Canton participant on startup.

## Overview

The DAML upload functionality allows you to:

- Define DAML smart contracts in the `daml/` directory
- Automatically build and package them when the validator starts
- Upload the compiled DAR file to the Canton participant
- Make the contracts available for use by your validator application

## Directory Structure

The DAML contracts are now located in the backend project (`../deserve/daml/`):

```
../deserve/daml/
├── daml.yaml              # DAML project configuration
├── Main.daml              # Main module with asset contracts
├── Validator.daml         # Validator-specific contracts
├── Investment.daml        # Investment pool management contracts
└── README.md              # DAML package documentation
```

## How It Works

### 1. DAML Package Structure

The `../deserve/daml/` directory contains a complete DAML project with:

- `daml.yaml`: Project configuration, dependencies, and exposed modules
- `.daml` files: Smart contract definitions
- Dependencies on standard DAML libraries

### 2. Build Process

When the validator starts:

1. The `daml-uploader` service starts after the participant is healthy
2. It runs `daml build` to compile the DAML code into a DAR file
3. The DAR file is uploaded to the participant using `daml ledger upload-dar`
4. The contracts become available for use

### 3. Docker Compose Integration

The `compose-daml-upload.yaml` file adds:

- A `daml-uploader` service using the DAML SDK image
- Volume mounts for the DAML directory and upload script
- Dependencies to ensure the participant is ready before upload

## Adding New Contracts

### Step 1: Create New DAML Files

Add new `.daml` files to the `../deserve/daml/` directory:

```daml
module MyNewContract where

import DA.Text

template MyTemplate
  with
    owner : Party
    data : Text
  where
    signatory owner

    choice UpdateData : ContractId MyTemplate
      with
        newData : Text
      controller owner
      do
        create this with data = newData
```

### Step 2: Update daml.yaml

Add the new module to the `exposed-modules` list:

```yaml
exposed-modules:
  - Main
  - Validator
  - MyNewContract # Add your new module here
```

### Step 3: Add Required Parties

If your contracts use new parties, add them to the `parties` list:

```yaml
parties:
  - issuer
  - owner
  - operator
  - validator
  - client
  - myNewParty # Add new parties here
```

## Testing

### Local Testing

Before deploying, test your DAML package locally:

```bash
# Test the build process
./test-daml-build.sh

# Or test directly in the backend project:
cd ../deserve/daml
daml build

# This will:
# - Validate the DAML project structure
# - Build the package
# - Show package contents and size
```

### Requirements

- DAML SDK installed locally (for testing)
- Docker and Docker Compose (for deployment)

## Configuration

### DAML SDK Version

The DAML SDK version is configured in:

- `daml/daml.yaml`: `sdk-version: 2.8.0`
- `compose-daml-upload.yaml`: `image: digitalasset/daml-sdk:2.8.0`

### Package Name and Version

Configure in `daml/daml.yaml`:

```yaml
name: dserv-validator-daml
version: 1.0.0
```

### Dependencies

Standard DAML dependencies are included:

```yaml
dependencies:
  - daml-prim
  - daml-stdlib
  - daml-script
```

## Troubleshooting

### Common Issues

1. **DAML SDK not found**

   - Ensure DAML SDK is installed for local testing
   - The Docker image includes the SDK for deployment

2. **Build failures**

   - Check DAML syntax in your `.daml` files
   - Verify module names match file names
   - Ensure all imports are available

3. **Upload failures**

   - Check that the participant is healthy
   - Verify network connectivity between services
   - Check participant logs for errors

4. **Module not found**
   - Ensure new modules are added to `exposed-modules` in `daml.yaml`
   - Check that file names match module names

### Debugging

1. **Check DAML uploader logs**:

   ```bash
   docker compose logs daml-uploader
   ```

2. **Check participant logs**:

   ```bash
   docker compose logs participant
   ```

3. **Test DAML build locally**:
   ```bash
   cd daml
   daml build
   ```

## Integration with Validator Application

Once uploaded, your DAML contracts are available to your validator application through:

- Canton's Ledger API
- DAML Script for automated testing
- Direct contract interactions

### Example Usage in Validator App

Your validator application can now:

- Create contracts using the uploaded templates
- Exercise choices on existing contracts
- Query contract state
- Handle contract events

## Best Practices

1. **Version Management**: Increment the version in `daml.yaml` when making changes
2. **Testing**: Always test locally before deploying
3. **Documentation**: Update the README.md in the daml/ directory
4. **Modular Design**: Keep contracts focused and well-organized
5. **Error Handling**: Include proper error handling in your contracts

## Security Considerations

- Contracts are uploaded with the validator's permissions
- Ensure proper access controls in your contract logic
- Review contract choices and signatories carefully
- Test thoroughly before production deployment
