"""
https://weather.msfc.nasa.gov/goes/abi/wxSatelliteAPI.html
"""

import requests
from bs4 import BeautifulSoup

BASE_URL="https://weather.msfc.nasa.gov/cgi-bin/get-abi?satellite=GOESEastfullDiskband{band:02d}&lat=13&lon=-54&zoom={zoom}&width={width}&height={height}&quality=80&past={past}&mapcolor=yellow"

def download_file(url, local_filename):
    # NOTE the stream=True parameter below
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()

def main():
    lat, lon = 13, -54
    zoom = 2
    width = 1600
    height = 900
    band = 2

    N = 30

    for n in range(N):
        m = N-n
        url = BASE_URL.format(
            lat=lat, lon=lon, zoom=zoom, width=width, height=height,
            past=n, band=band
        )

        fn = "img_{:0d}.png".format(m)

        r = requests.get(url)
        soup = BeautifulSoup(r.text, 'lxml')
        url_img = "https://weather.msfc.nasa.gov/" + soup.find('img')['src']
        print(url)
        print(url_img)
        download_file(url_img, fn)


if __name__ == "__main__":
    main()
