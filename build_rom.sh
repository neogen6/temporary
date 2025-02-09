# sync rom
repo init --depth=1 --no-repo-verify -u repo init -u https://github.com/AICP/platform_manifest.git -b t13.0 --git-lfs -g default,-mips,-darwin,-notdefault
git clone https://github.com/neogen6/local_manifests.git --depth 1 -b lineage-20.0 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch lineage_MiThoriumSSI-userdebug
export TZ=Asia/Kolkata #put before last build command
mka systemimage

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
zip out/target/product/MiThoriumSSI/MiThoriumSSI-AICP.zip out/target/product/MiThoriumSSI/*.img
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
