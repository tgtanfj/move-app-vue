import { defineStore } from 'pinia'
import { signInWithPopup, GoogleAuthProvider, signOut, onAuthStateChanged } from "firebase/auth";
import { auth } from '../services/firebaseConfig.js'
import { onMounted, ref } from 'vue';
import { HEADERS_DEFAULT } from '@constants/header.constant.js';
import { API_METHOD } from '@constants/api-method.constant.js';

export const useAuthStore = defineStore('auth', () => {
    // States
    const user = ref({})
    const error = ref(null);
    const token = ref(null);

    // Actions
    const googleSignIn = async () => {
        const provider = new GoogleAuthProvider()
        try {
            const result = await signInWithPopup(auth, provider);
            user.value = result.user;
            token.value = await result.user.getIdToken();
            console.log("User info:", user.value);
        } catch (err) {
            error.value = err.message;
            console.error("Error during Google login:", error.value);
        }
    }

    // Gửi idToken cho backend ( Pending )
    const sendTokenToBackend = async () => {
        if (token.value) {
            try {
                const response = await fetch('', { // đợi api của backend
                    method: API_METHOD.POST,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ idToken: token.value }),
                });
                const data = await response.json();
                console.log('Response from backend:', data);
            } catch (error) {
                console.error('Error sending token to backend:', error);
            }
        } else {
            console.error('No token available to send to backend');
        }
    };

    onMounted(() => {
        const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
            if (currentUser) {
                user.value = currentUser;
                currentUser.getIdToken().then((idToken) => {
                    token.value = idToken;
                });
            } else {
                user.value = null;
                token.value = null;
            }
        });
        return () => {
            unsubscribe();
        };
    });

    const logout = async () => {
        await auth.signOut()
        user.value = {};
    };

    // Chưa có api login từ backend ( Pending )
    const loginWithEmail = async (values) => {
        try {
            const response = await fetch('', {
                method: 'POST',
                headers: HEADERS_DEFAULT,
                body: JSON.stringify(values),
                credentials: 'include'
            });
    
            const data = await response.json();
            if(data.error) {
                alert(data.error)
            }
            user.value = data
            console.log('data', data)
        } catch (error) {
            console.log(error);
        }
    }

    return {
        // states
        user, error,
        // actions
        googleSignIn, sendTokenToBackend, logout, loginWithEmail
    }
})
