# Generated by precisionFDA exporter (v1.0.3) on 2018-06-14 16:22:56 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: platypus-2, revision: 8, authored by: lichy.han
# https://precision.fda.gov/apps/app-Bz3fp580KYVjgB8K9bQggbv5

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download app assets
RUN curl https://dl.dnanex.us/F/D/4JgX09Kk92bvXXxvXpg5KG3J2vq5KYQ0x364001v/hs37d5-fasta.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/fBpGkFpxjzFPxfBvJBYZZv4vzzQB38KKQqjfyvky/platypus_0.8.1.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/3Z8qp9Jpb7G0qjXyXP6g6fZvVgPXZV185Z7jzfXG/samtools-1.3.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"input\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"BAM\\ file\\ list\\\",\\\"help\\\":\\\"List\\ of\\ BAM\\ files\\\"\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"VariantCalls\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"VCF\\ files\\\",\\\"help\\\":\\\"Output\\ VCF\\ \\\"\\}\\],\\\"internet_access\\\":false,\\\"instance_type\\\":\\\"baseline-16\\\"\\},\\\"assets\\\":\\[\\\"file-Bk5y43Q0qVb0gjfqY8f9k4g8\\\",\\\"file-Bz3fX500ZZZ3Pvg5gky8bYfj\\\",\\\"file-BpBpb580qVbPkG0711FzfBYk\\\"\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"samtools\\ index\\ \\\\\\\"\\$input_path\\\\\\\"\\\\npython\\ /Platypus_0.8.1/Platypus.py\\ callVariants\\ --bamFiles\\=\\\\\\\"\\$input_path\\\\\\\"\\ --refFile\\=/work/hs37d5.fa\\ --output\\=\\\\\\\"\\$input_prefix\\\\\\\".VariantCalls.vcf\\\\nemit\\ VariantCalls\\ \\\\\\\"\\$input_prefix\\\\\\\".VariantCalls.vcf\\\\n\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work