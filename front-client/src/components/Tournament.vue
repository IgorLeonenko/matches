<template>
  <div id='tournament'>
    <div v-if="tournament">
      <div class='left'>
        <h3>Tournament {{tournament.title}}</h3>
        <router-link :to="{name: 'tournamentInfo', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentInfo'}">
          Info
        </router-link>
        <router-link :to="{name: 'tournamentTeams', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentTeams'}">
          Teams
        </router-link>
        <router-link :to="{name: 'tournamentMatches', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentMatches'}">
          Matches
        </router-link>
        <router-view :rounds="tournament.rounds"
                     :tournament="tournament"
                     :teams="tournament.teams">
        </router-view>
        <button type='button' @click="goBack()">Back</button>
      </div>
    </div>
  </div>
</template>

<script>
  import { router } from '../main'
  export default {
    name: 'Tournament',
    computed: {
      tournament () {
        var tournament = this.$store.getters.tournaments.findIndex(
          ({ id }) => id === this.$route.params.id
        )
        return this.$store.state.tournaments[tournament]
      }
    },
    methods: {
      goBack () {
        router.push('/tournaments')
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
    width: 70%;
    margin: 0 auto;
  }
  ul {
    list-style: none;
  }
  .left {
    float: left;
  }
  .active {
    color: green;
  }
</style>
