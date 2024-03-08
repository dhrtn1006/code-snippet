// crypto-js 설치 후 적용
// npm install crypto-js

export function setEnc(plainText) {
    const CryptoJS = require("crypto-js");

    const key = "onecKeyQWER1qazQWER3edcQWER2wsxo";
    const iv = "onecKeyQWER1qazQ";

    const encrypted = CryptoJS.AES.encrypt(plainText, CryptoJS.enc.Utf8.parse(key), {
        iv: CryptoJS.enc.Utf8.parse(iv),
        padding: CryptoJS.pad.Pkcs7,
        mode: CryptoJS.mode.CBC
    }).toString();
    
    return encrypted;
}

export function getDec(encrypted) {
    const CryptoJS = require("crypto-js");

    const key = "onecKeyQWER1qazQWER3edcQWER2wsxo";
    const iv = "onecKeyQWER1qazQ";
    
    const bytes  = CryptoJS.AES.decrypt(encrypted, CryptoJS.enc.Utf8.parse(key), {
        iv: CryptoJS.enc.Utf8.parse(iv),
        padding: CryptoJS.pad.Pkcs7,
        mode: CryptoJS.mode.CBC
    });
    const decrypted = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));

    return decrypted;
}