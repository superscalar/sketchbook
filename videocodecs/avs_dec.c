#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <stdlib.h>

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
typedef struct Slice {
	uint8_t* data;
	uint64_t length;
} Slice;

Slice LoadEntireFileIntoMemory(const char const* path) {
	HANDLE handle = CreateFileA(path, GENERIC_READ, 0, NULL, OPEN_ALWAYS, 0, NULL);
	BY_HANDLE_FILE_INFORMATION info = {0};
	if (!GetFileInformationByHandle(handle, &info)) {
		exit(-1);
	}

	Slice fileContents = {0};
	uint64_t size = info.nFileSizeLow;
	fileContents.length = size;
	fileContents.data = malloc(fileContents.length * sizeof(uint8_t));
	ReadFile(handle, &(fileContents.data), fileContents.length, NULL, NULL);

	CloseHandle(handle);
	return fileContents;
}

typedef struct Header {
	// uint32_t signature;
	uint32_t mainHeaderSize;
	uint32_t frameWidth;
	uint32_t frameHeight;
	uint32_t colorDepth;
	uint32_t fps;
	// uint8_t frameCount[4];
	uint64_t frameCount;
} Header;

int main(int argc, char const *argv[]){
	Slice contents = LoadEntireFileIntoMemory("samples/INT0_0.AVS");
	printf("%d\n", contents.length);

	for (int i = 0; i < 20; i++) {
		printf("%d; ", contents.data[i]);
	}

	printf("\n\n");

	uint8_t signature[2] = {0x77, 0x57};
	assert(memcmp(contents.data, signature, 2) == 0);

	Header h = {0};

	memcpy(&h, contents.data+2, sizeof(Header));

	printf("%dx%d\n", h.frameWidth, h.frameHeight);

	return 0;
}