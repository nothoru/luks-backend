    # analytics/management/commands/test_storage.py

import os
from django.core.management.base import BaseCommand
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile

class Command(BaseCommand):
    help = 'Tests the connection and upload to Azure Blob Storage.'

    def handle(self, *args, **options):
        self.stdout.write("--- Starting Azure Blob Storage Test ---")

        try:
            # Create a dummy file in memory
            dummy_content = b"This is a test file from a management command."
            file_to_save = ContentFile(dummy_content)

            # Define the destination path in the blob container
            destination_path = 'test_uploads/management_command_test.txt'

            self.stdout.write(f"Attempting to save file to: {destination_path}")

            # This is the critical line that performs the upload
            saved_path = default_storage.save(destination_path, file_to_save)

            # If it succeeds, we print success messages
            self.stdout.write(self.style.SUCCESS("File saved successfully!"))
            self.stdout.write(f"Returned path: {saved_path}")
            
            file_url = default_storage.url(saved_path)
            self.stdout.write(f"Public URL: {file_url}")

            # Verify the file exists in storage
            if default_storage.exists(saved_path):
                self.stdout.write(self.style.SUCCESS("Verification successful: File exists in blob storage."))
            else:
                self.stdout.write(self.style.ERROR("Verification FAILED: File does not exist in blob storage after saving."))

        except Exception as e:
            # If any part of the process fails, print the full error
            self.stdout.write(self.style.ERROR("--- AN ERROR OCCURRED ---"))
            self.stdout.write(self.style.ERROR(f"Error Type: {type(e).__name__}"))
            self.stdout.write(self.style.ERROR(f"Error Details: {e}"))
            # For more detailed tracebacks, you might need to check the main log stream
            import traceback
            traceback.print_exc()

        self.stdout.write("--- Azure Blob Storage Test Finished ---")