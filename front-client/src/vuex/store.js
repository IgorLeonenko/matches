import Vue from 'vue'
import Vuex from 'vuex'
import api from '../api'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    tournaments: []
  },
  mutations: {
    SET_TOURNAMENTS_LIST (state, tournaments) {
      state.tournaments = tournaments
    },
    ADD_TOURNAMENT (state, tournament) {
      state.tournaments.push(tournament)
    }
  },
  actions: {
    async getTournaments ({commit}) {
      let tournaments = await api.getTournaments()
      commit('SET_TOURNAMENTS_LIST', tournaments)
    },
    async addTournament ({commit}, tournament) {
      tournament = await api.createTournament(tournament)
      commit('ADD_TOURNAMENT', tournament)
    }
  }
})
