# backend/custom_storages.py

from storages.backends.azure_storage import AzureStorage
import os

class AzureMediaStorage(AzureStorage):
    account_name = os.getenv('AZURE_ACCOUNT_NAME')
    account_key = None # We will use the connection string
    azure_container = os.getenv('AZURE_CONTAINER')
    expiration_secs = None
    connection_string = os.getenv('AZURE_STORAGE_CONNECTION_STRING')