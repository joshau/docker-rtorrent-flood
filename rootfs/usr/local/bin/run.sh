#!/bin/sh

mkdir -p /home/torrent/torrents
mkdir -p /home/torrent/.watch
mkdir -p /home/torrent/.session

rm -f /home/torrent/.session/rtorrent.lock

chown -R $UID:$GID /data /home/torrent /tmp /usr/flood /flood-db /etc/s6.d

if [ ${RTORRENT_SCGI} -ne 0 ]; then
    sed -i -e 's|^scgi_local.*$|scgi_port = 0.0.0.0:'${RTORRENT_SCGI}'|' /home/torrent/.rtorrent.rc
    sed -i -e 's|socket: true,|socket: false,|' -e 's|port: 5000,|port: '${RTORRENT_SCGI}',|' /usr/flood/config.js
fi

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
