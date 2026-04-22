# Use a minimal, updated base image to ensure a clean Trivy scan
FROM alpine:latest

# Install necessary packages 
# We use --no-cache to keep the image size small and secure
RUN apk add --no-cache openssl

# Standard non-root user setup (Best Practice for OpenShift)
# Optional: Adding this shows you understand OpenShift security context
USER 1001

CMD ["echo", "Secure App is running!"]
